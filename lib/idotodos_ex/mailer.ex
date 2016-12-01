defmodule IdotodosEx.Mailer do
  @config domain: Application.get_env(:idotodos_ex, :mailgun_domain),
          key: Application.get_env(:idotodos_ex, :mailgun_key),
          mode: Mix.env,
          test_file_path: "/tmp/mailgun.json"
  use Mailgun.Client, @config

  @from "noreply@idotodos.com"
  
  def send_mail(to, subject, html) do
     send_email to: to,
             from: @from,
             subject: subject,
             html: html
  end
end