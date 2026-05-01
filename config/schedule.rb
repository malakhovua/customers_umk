set :environment, ENV['RAILS_ENV'] || :production
set :output, {
  standard: 'log/cron.log',
  error:    'log/cron_error.log'
}

#set :bundle_command, "/usr/local/bin/bundle exec"
bundle_path = `which bundle`.strip
set :bundle_command, "#{bundle_path} exec"
set :job_template, "bash -l -c ':job'"

job_type :runner, "cd :path && DISABLE_SPRING=1 :bundle_command rails runner -e :environment ':task' :output"

every 5.minutes do
  runner "Unf.new.post_orders('', '', '', true)"
end

every 30.minutes do
  runner "Unf.new.get_all_data"
end

every 60.minutes do
  runner "Unf.new.get_regular_prices"
end

every 10.minutes do
  runner "ApplicationJob.new.get_expense_invoices"
end

every 120.minutes do
  runner "ApplicationJob.new.delete_old_empty_carts"
end