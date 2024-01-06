
pub fn longest_subsequence_increasing(arr: &[i32]) -> Vec<i32> {
    let mut l = vec![1; arr.len()];
    let mut prev: Vec<i32> = vec![0; arr.len()];
    let mut cprev: i32;
    let mut clen;

    for i in 0..arr.len() {
        cprev = -1;
        clen = 1;
        for j in (0..i).rev() {
            if arr[i] > arr[j] {
                if clen < l[j] + 1 {
                    cprev = j as i32;
                    clen = l[j] + 1;
                }
            }
        }
        prev[i] = cprev;
        l[i] = clen;
    }

    let mut maxl = 0;
    let mut maxl_idx = 0;
    for i in 0..arr.len() {
        if maxl < l[i] {
            maxl = l[i];
            maxl_idx = i;
        }
    }

    let mut res = vec![0; maxl];
    let mut i = maxl_idx;
    for j in (0..maxl).rev() {
        res[j] = arr[i];
        i = prev[i] as usize;
    }

    res
}


#[cfg(test)]
mod tests {
    use super::longest_subsequence_increasing;
    #[test]
    fn large_floors() {
        assert_eq!(longest_subsequence_increasing(&[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
        assert_eq!(longest_subsequence_increasing(&[1, 2, 3, 4, 55, 65, 75, 85, 95, 105]), vec![1, 2, 3, 4, 55, 65, 75, 85, 95, 105]);
    }

    #[test]
    fn test_example_1() {
        assert_eq!(
            longest_subsequence_increasing(&[10, 9, 2, 5, 3, 7, 101, 18, 25]),
            vec![2, 3, 7, 18, 25]
        );
    }

    #[test]
    fn test_example_2() {
        assert_eq!(
            longest_subsequence_increasing(&[10, 9, 2, 5, 15, 24, 35, 56, 77,  7, 3, 9, 10]),
            vec![2, 5, 15, 24, 35, 56, 77]
        );
    }

    #[test]
    fn test_example_3() {
        assert_eq!(
            longest_subsequence_increasing(&[1, 50, 3, 55, 5, 65, 7, 75, 9, 85, 10, 95, 16, 17, 18, 20, 34, 56, 88]),
            vec![1, 3, 5, 7, 9, 10, 16, 17, 18, 20, 34, 56, 88]
        );
    }

    #[test]
    fn test_example_4() {
        assert_eq!(
            longest_subsequence_increasing(&[65, 55, 45, 35, 77, 25, 10, 5]),
            vec![35, 77]
        );
    }
}