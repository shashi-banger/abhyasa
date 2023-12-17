
defmodule CliJson.CLI do

  def main(argv) do
    pr = process_args(argv)
    IO.puts "pr: #{pr}"
  end

  def process_json(json_str) do
    IO.puts "Input: #{json_str}"
    json_str
    |> Jason.decode!()
  end

  def process_json_file(filename) do
    json_map = File.read!(filename) |>
               process_json
    IO.puts "json_map: #{:maps.keys(json_map)}"

  end

  def process_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean, input: :string],
      aliases: [h: :help, i: :input])
    case parse do
      {[help: true], _, _} -> :help
      {[input: filename], _, _} -> process_json_file(filename)
      _ -> :help
    end
  end

end
