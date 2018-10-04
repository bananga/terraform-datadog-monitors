resource "datadog_monitor" "datadog_process_check" {
  count   = "${var.process_check_enabled ? 1 : 0}"
  name    = "[${var.environment}] Process is down"
  message = "${coalesce(var.process_check_message, var.message)}"

  query = <<EOQ
    "process.up"${module.filter-tags.service_check}.by("host","dd_process_name").last(3).count_by_status()"
EOQ

  type = "service check"

  thresholds {
    ok       = 1
    warning  = 1
    critical = 2
  }

  notify_no_data    = true
  no_data_timeframe = "${var.process_check_no_data_timeframe}"
  new_host_delay    = "${var.new_host_delay}"
  notify_audit      = false
  timeout_h         = 0
  include_tags      = true
  locked            = false

  silenced = "${var.process_check_silenced}"

  tags = ["env:${var.environment}", "type:process", "provider:process-check", "resource:custom", "team:claranet", "created-by:terraform", "${var.process_check_extra_tags}"]
}
