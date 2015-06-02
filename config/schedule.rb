# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever


# Vaciar el almacen de recepcion
every 4.hours do
  runner "Bodega.vaciar_recepcion"
end

every 10.hours do
  runner "Bodega.vaciar_pulmon"
end

every 2.hours do
  runner "FtpManager.ftp"
end

every 1.minute do
  runner "CompraB2B.test_whenever"
end

every 5.hours do
  runner "Bodega.revisar_stock"
end