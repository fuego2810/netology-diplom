# Расписание снапшотов: ежедневно и храним по 7 дней
resource "yandex_compute_snapshot_schedule" "daily_snapshots" {
  name = "daily-snapshots"

  schedule_policy {
    # Каждый день 05:00 МСК
    expression = "0 2 * * *"
  }

  # Хранить не более 7 снапшотов (1 неделя)
  retention_period = "168h"

  snapshot_spec {
    description = "daily-auto-snapshot"
  }

  # Диски всех вмок
  disk_ids = [
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.web1.boot_disk[0].disk_id,
    yandex_compute_instance.web2.boot_disk[0].disk_id,
    yandex_compute_instance.zabbix.boot_disk[0].disk_id,
    yandex_compute_instance.elastic.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id,
  ]
}
