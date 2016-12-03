defmodule IdotodosEx.PartyInviteEmailStatusControllerTest do
    use IdotodosEx.AuthConnCase

    alias IdotodosEx.Party
    alias IdotodosEx.Campaign
    alias IdotodosEx.Invite
    alias IdotodosEx.Repo

    @invalid_attrs_with_bad_keys %{
        description: "some content",
        event: "some content",
        reason: "some content",
        recipient: "some content", 
        timestamp: "some content", 
        url: "some content",
        party_id: 2,
        campaign_id: 3, 
        invite_id: 4
    }
    @invalid_attrs %{
        recipient: "some content", 
        timestamp: "some content", 
        url: "some content"
    }
    test "should return a 400 with invalid attrs", %{conn: conn} do
        conn = post conn, party_invite_email_status_path(conn, :create, @invalid_attrs)
        assert conn.status == 400
        assert String.contains?(conn.resp_body, "Invalid Data")
    end

    test "should return a 400 with valid attrs but no foreign keys", %{conn: conn} do
        conn = post conn, party_invite_email_status_path(conn, :create, @invalid_attrs_with_bad_keys)
        assert conn.status == 400
        assert String.contains?(conn.resp_body, "error")
    end

    test "should return a 200 with valid attrs", %{conn: conn} do

        user_changeset = %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho+2@gmail.com", password: "a123123", password_confirmation: "a123123"}
        partner_changeset =  %{first_name: "Sara", last_name: "Noonan"}
        campaign_struct = %{
        main_date: %{day: 17, month: 4, year: 2010}, 
        name: "foo", 
        user: user_changeset, 
        partner: partner_changeset
        }
        changeset = Campaign.registration_changeset(%Campaign{}, campaign_struct)
        assert changeset.valid?
        {_, campaign} = Repo.insert(changeset)

        attrs = %{ name: "foo",max_party_size: 2, guests: [%{first_name: "foo", last_name: "bar", campaign_id: campaign.id}], campaign_id: campaign.id}
        changeset = Party.changeset_with_guests(%Party{}, attrs)
        assert changeset.valid?
        {_, party} = Repo.insert(changeset)

        invite = Invite.changeset(%Invite{}, %{
            name: "foo",
            type: "foo",
            html: "foo",
            subject: "foo",
            campaign_id: campaign.id
        })
        |> Repo.insert! 

        valid_attrs = Map.merge(@invalid_attrs_with_bad_keys, %{
            invite_id: invite.id,
            party_id: party.id,
            campaign_id: campaign.id
        })
        conn = post conn, party_invite_email_status_path(conn, :create, valid_attrs)
        assert conn.status == 200
        assert String.contains?(conn.resp_body, "some content")
    end
end