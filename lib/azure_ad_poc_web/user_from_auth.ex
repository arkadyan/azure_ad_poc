defmodule AzureAdPocWeb.UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  require Jason
  require Logger

  alias Ueberauth.Auth

  @type basic_info :: %{
          id: String.t(),
          name: String.t()
        }

  @spec find_or_create(Auth.t()) :: {:ok, basic_info()} | {:error, String.t()}
  def find_or_create(%Auth{provider: :identity} = auth) do
    case validate_pass(auth.credentials) do
      :ok ->
        {:ok, basic_info(auth)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_or_create(%Auth{} = auth) do
    {:ok, basic_info(auth)}
  end

  @spec basic_info(Auth.t()) :: basic_info()
  defp basic_info(auth) do
    %{id: auth.uid, name: name_from_auth(auth)}
  end

  @spec name_from_auth(Auth.t()) :: String.t()
  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end

  @spec validate_pass(Auth.Credentials.t()) :: :ok | {:error, String.t()}
  defp validate_pass(%{other: %{password: nil}}), do: {:error, "Password required"}

  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}), do: :ok

  defp validate_pass(%{other: %{password: _}}), do: {:error, "Passwords do not match"}

  defp validate_pass(_), do: {:error, "Password Required"}
end
