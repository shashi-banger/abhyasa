package main

import (
	"fmt"

	"math"
)

func correction(drop_timecode string) float64 {
	hh := 0
	mm := 0
	ss := 0
	ff := 0
	fmt.Sscanf(drop_timecode, "%02d:%02d:%02d;%02d", &hh, &mm, &ss, &ff)

	modulo_10min_in_sec := (hh*60*60 + mm*60) % (10 * 60)

	num_min_in_modulo := modulo_10min_in_sec / 60

	frames_at_30fps_since_10th_min := (modulo_10min_in_sec+ss)*30 + ff

	frames_at_29_97_fps_since_10th_min := frames_at_30fps_since_10th_min - (num_min_in_modulo * 2)

	correction := (float64(frames_at_29_97_fps_since_10th_min) / 29.97) - (float64(frames_at_30fps_since_10th_min) / 30)

	return correction
}

// Drop timecode to timestamp conversion
func drop_timecode_to_timestamp(drop_timecode string) float64 {
	hh := 0
	mm := 0
	ss := 0
	ff := 0
	fmt.Sscanf(drop_timecode, "%02d:%02d:%02d;%02d", &hh, &mm, &ss, &ff)

	ts := float64(hh*60*60+mm*60+ss) + float64(ff)/30
	ts += correction(drop_timecode)
	return ts
}

func roundFloat(val float64, precision uint) float64 {
	ratio := math.Pow(10, float64(precision))
	return math.Round(val*ratio) / ratio
}

// timestamp_to_drop_timecode converts "actual" timestamp to drop frame timecode
func timestamp_to_drop_timecode(ts_sec float64) string {
	var num_min_since_10th_mod_min int
	modulo_10th_min := int(ts_sec) / (10 * 60)
	absolute_time_at_10th_mod_min := float64(modulo_10th_min * 600)

	time_in_sec_since_10th_mod_min := float64(ts_sec) - absolute_time_at_10th_mod_min

	//num_min_in_modulo := int((time_in_sec_since_10th_mod_min) / 60)
	if int(time_in_sec_since_10th_mod_min/60) <= 5 {
		v := roundFloat(float64(time_in_sec_since_10th_mod_min-(1/29.97)), 3)
		num_min_since_10th_mod_min = int(v / 60.)
	} else {
		num_min_since_10th_mod_min = int(time_in_sec_since_10th_mod_min / 60)
	}

	actual_frames_29_97 := int(math.Round(float64(time_in_sec_since_10th_mod_min * 29.97)))

	equivalent_30_fps_frames := (actual_frames_29_97 + (num_min_since_10th_mod_min * 2))

	total_time_in_30_fps := (float64(absolute_time_at_10th_mod_min)) + float64(equivalent_30_fps_frames)/30.

	hh := int(total_time_in_30_fps / 3600)
	mm := int((total_time_in_30_fps - float64(hh*3600)) / 60)
	ss := int(total_time_in_30_fps - float64(hh*3600+mm*60))
	ff := int(math.Round(float64((total_time_in_30_fps - float64(hh*3600+mm*60+ss)) * 30)))

	return fmt.Sprintf("%02d:%02d:%02d;%02d", hh, mm, ss, ff)
}

func main() {
	frame_num_in30fps := 0
	frame_num_in29_97fps := 0
	dropped_frames := 0
	var diff float64
	for i := 0; i < 1800*1000+1; i++ {
		diff = (float64(frame_num_in30fps)/30. - (float64(frame_num_in29_97fps) / 29.97))
		timecode := fmt.Sprintf("%02d:%02d:%02d;%02d", frame_num_in30fps/108000, (frame_num_in30fps/1800)%60, (frame_num_in30fps/30)%60, frame_num_in30fps%30)

		derived_ts := drop_timecode_to_timestamp(timecode)

		actual_time := float64(frame_num_in29_97fps) / 29.97

		derived_time_code := timestamp_to_drop_timecode(actual_time)

		//fmt.Printf("%d %.3f %s %.3f %s %.3f %d\n", frame_num_in29_97fps, actual_time, timecode, derived_ts, derived_time_code, diff, dropped_frames)

		if timecode != derived_time_code {
			fmt.Printf("Mismatch %d %.3f %s %.3f %s %.3f %d\n", frame_num_in29_97fps, actual_time, timecode, derived_ts, derived_time_code, diff, dropped_frames)
		}

		if (actual_time - derived_ts) > 0.03 {
			fmt.Printf("Mismatch %d %.3f %s %.3f %s %.3f %d\n", frame_num_in29_97fps, actual_time, timecode, derived_ts, derived_time_code, diff, dropped_frames)
		}

		if (frame_num_in30fps+1)%1800 == 0 && ((frame_num_in30fps+1)%18000) != 0 {
			frame_num_in30fps += 3
			dropped_frames += 2
		} else {
			frame_num_in30fps++
		}
		frame_num_in29_97fps++
	}
}
