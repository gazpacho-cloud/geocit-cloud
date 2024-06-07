
module "Autoscaling_instances" {
  depends_on =[google_compute_network.static,time_sleep.wait_60_seconds]
  source     = "./modules/Autoscaling_instances"
  network    = google_compute_network.static.id
  subnetwork = google_compute_subnetwork.sub_for_instances.id

}

module "Compute_instance" {
  depends_on =[google_compute_network.static,time_sleep.wait_60_seconds]
  source     = "./modules/Compute_instance"
  network    = google_compute_network.static.id
  subnetwork = google_compute_subnetwork.my_custom_subnet_for_grafane1.id
}

module "PSQL_DB" {
  depends_on =[google_compute_network.static,time_sleep.wait_60_seconds]
  source  = "./modules/PSQL_DB"
  network = google_compute_network.static.id
  #vpc_peering_to_db = google_service_networking_connection.private_vpc_connection.id
  subnetwork = google_compute_subnetwork.my_custom_subnet_for_postgres.id
}

module "dns" {
  depends_on =[google_compute_network.static,time_sleep.wait_60_seconds]
  source         = "./modules/dns"
  global_address = google_compute_global_address.default.address

}
module "firewalls" {
  depends_on =[google_compute_network.static,time_sleep.wait_60_seconds]
  source  = "./modules/firewalls"
  network = google_compute_network.static.id

}

module "load_balancer" {
  depends_on =[google_compute_network.static,time_sleep.wait_60_seconds]
  source            = "./modules/load_balancer"
  instance_template = module.Autoscaling_instances.instance_template
  global_address    = google_compute_global_address.default.id

}

module "NAT" {
  source = "./modules/NAT"
  depends_on =[google_compute_network.static,time_sleep.wait_60_seconds]
}