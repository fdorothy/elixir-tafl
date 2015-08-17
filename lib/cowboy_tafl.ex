defmodule WebServer do

  def start(_type, _args) do
    dispatch = :cowboy_router.compile([
      { :_,
        [
          {"/", :cowboy_static, {:priv_file, :tafl, "index.html"}},
          {"/static/[...]", :cowboy_static, {:priv_dir, :tafl, "static_files"}},
        ]}
    ])

    { :ok, _ } = :cowboy.start_http(:http, 
                                    100,
                                    [{:port, 8080}],  
                                    [{ :env, [{:dispatch, dispatch}]}]
    ) 

  end

end
