defmodule IdotodosEx.MailerTest do
    use IdotodosEx.LibCase
    import IdotodosEx.Mailer

    setup_all do
        Mailgun.start
    end
    test "send email sends an email to a user from noreply@idotodos.com" do
        file_path = "/tmp/mailgun.json"
        attrs = %{to: "foo@gmail.com", subject: "FOOOOO", html: "hi there dudes <strong>yo</strong>"}
        {_, message} = send_mail(attrs.to, attrs.subject, attrs.html)
        assert message == "OK"
    
        file_contents = File.read!(file_path)
        assert file_contents == "{\"to\":\"#{attrs.to}\",\"subject\":\"#{attrs.subject}\",\"html\":\"#{attrs.html}\",\"from\":\"noreply@idotodos.com\"}"
    end
end