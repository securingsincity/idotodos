defmodule IdotodosEx.UserTest do
  use IdotodosEx.ModelCase
  alias IdotodosEx.Repo
  alias IdotodosEx.User

  @valid_attrs %{
    first_name: "James", 
    gender: "male", 
    last_name: "Hrisho", 
    middle_name: "some content",
    password: "some content",
    password_confirmation: "some content",
    state: "some content", 
    street: "some content", 
    city: "some content", 
    suite: "some content", 
    zip_code: "02141",
    email: "james.hrisho@gmail.com"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
    {_, result} =  fetch_change(changeset, :is_admin)
    refute result
  end

  test "changeset with valid attributes downcase email" do
    changeset = User.changeset(%User{}, %{@valid_attrs| email: "James.HRISHO@gmail.com" } )
    assert changeset.valid?
    {_, result} =  fetch_change(changeset, :email)
    assert result == "james.hrisho@gmail.com"
  end

  test "changeset with invalid attributes empty data" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid attributes invalid email" do
    invalid = %{@valid_attrs | email: "foobar"}
    changeset = User.changeset(%User{}, invalid)
    refute changeset.valid?
  end

  test "registration changeset with invalid attributes invalid email" do
    invalid = %{@valid_attrs | email: "foobar"}
    changeset = User.registration_changeset(%User{}, invalid)
    refute changeset.valid?
  end

  test "valid registration changeset creates a password_hash value" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
    {_, result} =  fetch_change(changeset, :password_hash)
    assert result !== "some content"
  end

  test "invalid registration changeset  when password is tooshort" do
    invalid = %{@valid_attrs | password: "abc"}
    changeset = User.registration_changeset(%User{},invalid)
    refute changeset.valid?
  end

  test "valid admin registration changeset should be an admin" do
    changeset = User.admin_registration_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
    {_, result} =  fetch_change(changeset, :is_admin)
    assert result
    
  end

  test "invalid admin registration changeset  when password is tooshort" do
    invalid = %{@valid_attrs | password: "abc"}
    changeset = User.admin_registration_changeset(%User{},invalid)
    refute changeset.valid?
  end
  

  test "invalid admin registration changeset  when password dont match" do
    invalid = %{@valid_attrs | password_confirmation: "abc123"}
    changeset = User.admin_registration_changeset(%User{},invalid)
    refute changeset.valid?
  end
  
  test "validate uniqueness constraint on email" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
    Repo.insert!(changeset)
    new_changeset = User.changeset(%User{}, @valid_attrs)
    {_error, changeset_results} = Repo.insert(new_changeset)
    refute changeset_results.valid?
  end

  test "valid partner_changeset only requires first_name last_name but can't be admin" do
    changeset = User.partner_changeset(%User{}, %{first_name: "Sara", last_name: "Noonan", is_admin: true})
    assert changeset.valid?
    {_, result} =  fetch_change(changeset, :is_admin)
    refute result
  end

  test "2 valid partner_changesets can be saved" do
    changeset = User.partner_changeset(%User{}, %{first_name: "Sara", last_name: "Noonan"})
    second_changeset = User.partner_changeset(%User{}, %{first_name: "James", last_name: "Hrisho"})
    assert changeset.valid?
    assert  second_changeset.valid?
    Repo.insert!(changeset)
    {result, _user} = Repo.insert(second_changeset)
    assert result
  end

  test "invalid partner_changeset requires first_name last_name " do
    changeset = User.partner_changeset(%User{}, %{first_name: "Sara"})
    refute changeset.valid?
  end
end
