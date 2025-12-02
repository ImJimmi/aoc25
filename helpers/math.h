#pragma once

#include <ranges>
#include <string_view>

namespace helpers
{
    [[nodiscard]] inline constexpr auto parse_int(std::string_view view) noexcept
    {
        if (std::empty(view))
            return 0;

        auto negative = view.front() == '-';
        auto start = negative ? 1zu : 0zu;
        auto result = 0;

        for (auto character : view.substr(start))
        {
            const auto digit = static_cast<int>(character - '0');

            if (digit < 0 || digit > 9)
                break;

            result = result * 10 + digit;
        }

        return negative ? -result : result;
    }
} // namespace helpers
