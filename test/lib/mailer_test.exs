defmodule IdotodosEx.MailerTest do
    use IdotodosEx.LibCase
    import IdotodosEx.Mailer

    setup_all do
        Mailgun.start
    end
    test "send email sends an email to a user from noreply@idotodos.com" do
        file_path = "/tmp/mailgun.json"
        attrs = %{to: "foo@gmail.com", subject: "FOOOOO", html: "hi there dudes <strong>yo</strong>"}
        {_, message} = send_mail(attrs.to, attrs.subject, attrs.html, "")
        assert message == "OK"
    
        file_contents = File.read!(file_path)
        assert file_contents == "{\"to\":\"#{attrs.to}\",\"text\":\"\",\"subject\":\"#{attrs.subject}\",\"html\":\"#{attrs.html}\",\"from\":\"noreply@idotodos.com\"}"
    end
    test "send email sends an email to a user from noreply@idotodos.com with text as well" do
        file_path = "/tmp/mailgun.json"
        attrs = %{to: "foo@gmail.com", subject: "FOOOOO", html: "hi there dudes <strong>yo</strong>", text: "hi james"}
        {_, message} = send_mail(attrs.to, attrs.subject, attrs.html, attrs.text)
        assert message == "OK"
    
        file_contents = File.read!(file_path)
        assert file_contents == "{\"to\":\"#{attrs.to}\",\"text\":\"hi james\",\"subject\":\"#{attrs.subject}\",\"html\":\"#{attrs.html}\",\"from\":\"noreply@idotodos.com\"}"
    end

    test "send email with additional variables as well" do
        file_path = "/tmp/mailgun.json"
        attrs = %{to: "foo@gmail.com", subject: "FOOOOO", html: "hi there dudes <strong>yo</strong>", text: "hi james"}
        {_, message} = send_mail(attrs.to, attrs.subject, attrs.html, attrs.text, %{
            campaign_id: 1,
            party_id: 5,
        })
        assert message == "OK"
    
        file_contents = File.read!(file_path)
        assert file_contents == "{\"v:party_id\":5,\"v:campaign_id\":1,\"to\":\"#{attrs.to}\",\"text\":\"hi james\",\"subject\":\"#{attrs.subject}\",\"html\":\"#{attrs.html}\",\"from\":\"noreply@idotodos.com\"}"
    end
end