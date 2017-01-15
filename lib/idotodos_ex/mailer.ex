defmodule IdotodosEx.Mailer do
  @config domain: Application.get_env(:idotodos_ex, :mailgun_domain),
          key: Application.get_env(:idotodos_ex, :mailgun_key),
          mode: Mix.env,
          test_file_path: "/tmp/mailgun.json"
  use Mailgun.Client, @config
  @from "noreply@idotodos.com"
  
  def send_mail(to, subject, html, text, variables \\ %{}) do
     email =  %{
        to: to,
        from: @from,
        subject: subject,
        html: html,
        text: text
     }
     if variables do
        custom_variables = Enum.map(variables, fn {k, v} -> {"v:#{k}", v} end)
        email = Dict.merge(email, custom_variables)
        send_email email
     else 
        send_email email
     end
  end

  def send_mail(email, variables \\ %{}) do
     if variables do
        custom_variables = Enum.map(variables, fn {k, v} -> {"v:#{k}", v} end)
        email = Dict.merge(email, custom_variables)
        send_email email
     else 
        send_email email
     end
  end
end