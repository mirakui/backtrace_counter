path = Rails.root.join('tmp/backtrace.csv')
printer = BacktraceCounter::CsvPrinter.new path

Rails.application.config.middleware.use BacktraceCounter::Middleware,
  printer: printer,
  backtrace_filter: lambda {|line| line =~ /#{Rails.root}/ },
  methods: ['ActiveRecord::Persistence::ClassMethods#instantiate', /^ActiveRecord::Result/]
