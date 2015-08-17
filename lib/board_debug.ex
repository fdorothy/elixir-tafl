defmodule BoardDebug do

	def to_s(state) do
		s = ""
		s = s <> board_to_s(state[:pieces]) <> "\n"
		s = s <> "turn: " <> to_string(state[:turn]) <> "\n"
	end
	def board_to_s(pieces) when is_tuple(pieces) do Tuple.to_list(pieces) |> board_to_s end
	def board_to_s([]) do "" end
	def board_to_s([h|t]) do
		row_to_s(h) <> "\n" <> board_to_s(t)
	end
	def row_to_s(row) when is_tuple(row) do Tuple.to_list(row) |> row_to_s end
	def row_to_s([]) do "" end
	def row_to_s([h|t]) do
		case h do
			0 -> "." <> " " <> row_to_s(t)
			_ -> to_string(h) <> " " <> row_to_s(t)
		end
	end

end
