#include "input.h"

#include <helpers/math.h>

#include <algorithm>
#include <numeric>
#include <print>
#include <ranges>

namespace day01
{
    [[nodiscard]] static constexpr auto part1() noexcept
    {
        return std::ranges::count_if(
            std::views::split(input, '\n')
                | std::views::transform([](auto&& line) {
                      return std::string_view{ std::begin(line), std::end(line) };
                  })
                | std::views::transform([](auto&& line) {
                      return (line.starts_with("L") ? -1 : 1)
                           * helpers::parse_int(line.substr(1));
                  }),
            [resultantAngle = 50](auto&& angle) mutable {
                resultantAngle = (resultantAngle + angle) % 100;
                return resultantAngle == 0;
            });
    }
} // namespace day01

[[nodiscard]] int main() // NOLINT(bugprone-exception-escape)
{
    static constexpr auto part1 = day01::part1();
    std::println("Part 1: {}", part1);
    return 0;
}
