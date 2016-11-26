defmodule IdotodosEx.UserPartyControllerTest do
    use IdotodosEx.AuthConnCase

    alias IdotodosEx.Party
    alias IdotodosEx.Repo
    test "should list parties and guest numbers", %{conn: conn} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        attrs = %{
            name: "foobar",
            max_party_size: 2,
            guests: [
                %{first_name: "jerry", last_name: "seinfeld"}
            ],
            campaign_id: user.campaign_id
        } 
        changeset = Party.changeset_with_guests(%Party{}, attrs)
        Repo.insert!(changeset)

        conn = get conn, user_party_path(conn, :index)
        assert html_response(conn, 200) =~ "Your Guests"
        assert html_response(conn, 200) =~ "jerry seinfeld"
        

    end

    test "should not list another user's parties and guests" do
        
    end
end