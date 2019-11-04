defmodule CpuschedulerHttpServer.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)

  plug(:dispatch)

  post "/calculate" do
    {:ok, body, conn} = read_body(conn)
    Logger.info("DATA RECEIVED: #{body}")

    schedule_data_json_object =
      CpuschedulerAdapter.calculate_cpu_schedule_data_from_json_object(body)

    Logger.info("DATA SENT: #{schedule_data_json_object}")

    send_resp(conn, 200, schedule_data_json_object)
  end

  # Default route that will get called when no other route is matched.
  match _ do
    send_resp(conn, 404, "not found")
  end
end
