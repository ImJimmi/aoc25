#include <iostream>
#include <print>

[[nodiscard]] static constexpr auto run() noexcept
{
    return 0;
}

[[nodiscard]] int main() // NOLINT(bugprone-exception-escape)
{
    static constexpr auto result = run();
    std::println("Solution:\n    {}", result);
    return 0;
}
