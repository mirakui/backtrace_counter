module BacktraceCounter
  class Middleware
    def initialize(app, config={})
      @app = app
      @config = config
    end

    def call(env)
      raise RuntimeError, 'Please set :methods like [[Klass1, :method1], [Klass2, :method2]], ... ' unless @config[:methods]
      raise RuntimeError, 'Please set :printer' unless @config[:printer]

      result = nil
      BacktraceCounter.start(@config[:methods]) do
        result = @app.call(env)
      end
      @config[:printer].print BacktraceCounter.backtraces
      BacktraceCounter.clear
      result
    end
  end
end
