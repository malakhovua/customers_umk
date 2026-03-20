# config/schedule.rb
set :environment, ENV['RAILS_ENV'] || :production
set :output, {
  standard: 'log/cron.log',
  error:    'log/cron_error.log'
}

set :bundle_command, "/usr/local/bin/bundle exec"
set :job_template, "bash -c ':job'"

job_type :runner, "cd :path && DISABLE_SPRING=1 :bundle_command rails runner -e :environment ':task' :output"

every 5.minutes do
  runner "Unf.new.post_orders('', '', '', true)"
end

every 30.minutes do
  runner "Unf.new.get_all_data"
end

