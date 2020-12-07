defmodule SearchEngine.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
  
  alias Services.EntityService

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  post "/search-engine/entities" do 
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body)
    IO.inspect(body)
    response =  EntityService.add_entity(body)
    IO.inspect(response)
    response |> handle_response(conn)
  end  
  
  get "/search-engine/entities" do
    query_param = 
      fetch_query_params(conn) 
      |> Map.get(:params)
      |> Map.get("q")
                  
    IO.inspect query_param
    response = EntityService.get_entity(query_param) 
    IO.inspect response |> Poison.encode
    send_resp(conn, 200, "Indexes")
  
  end
  
  defp handle_response(response, conn) do  
    case response do 
      {:ok, message} -> conn |> send_resp(200, message)
      {:not_found, message} -> conn |> send_resp(404 , message)
      {:malformed_data, message} -> conn |> send_resp(400, message)
      {:server_error, _} -> conn |> send_resp(500,"An error occurred internally")
    end
  end
end
