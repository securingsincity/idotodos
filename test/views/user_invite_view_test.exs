defmodule IdotodosEx.UserInviteViewTest do
    use ExUnit.Case
    alias IdotodosEx.UserInviteView
    test "format_type should return Save The Date if it looks like savethedate" do
        assert UserInviteView.format_type("savethedate") == "Save The Date"
    end
    test "format_type should return Wedding if it looks like wedding" do
        assert UserInviteView.format_type("wedding") == "Wedding"
    end
    test "format_type should return Other if it looks like anything else" do
        assert UserInviteView.format_type("fooo") == "Other"
    end
end