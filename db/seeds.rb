student_a = Student.create(username: "student_a", email: "student_a@msn.com", password: "pw", address: "137 Norfolk St New York, NY 10002", latlong: "40.720154,-73.986703")

student_b = Student.create(username: "student_b", email: "student_b@msn.com", password: "pw", address: "108 Clinton St, New York, NY 10002", latlong: "40.718536,-73.985501")

student_c = Student.create(username: "student_c", email: "student_c@msn.com", password: "pw", address: "130 Columbia St, New York, NY 10002", latlong: "40.719304,-73.978532")

student_d = Student.create(username: "student_d", email: "student_d@msn.com", password: "pw", address: "300 E 4th St, New York, NY 10009", latlong: "40.722260,-73.980485")

provider_a = Provider.create(username: "provider_a", email: "provider_a@msn.com", password: "pw", address: "140 Essex St, New York, NY 10002", latlong: "40.720218,-73.987056")

provider_b = Provider.create(username: "provider_b", email: "provider_b@msn.com", password: "pw", address: "105 Clinton St, New York, NY 10009", latlong: "40.718152,-73.985713")

provider_c = Provider.create(username: "provider_c", email: "provider_c@msn.com", password: "pw", address: "140 Columbia St, New York, NY 10002", latlong: "40.719332,-73.978661")

provider_d = Provider.create(username: "provider_d", email: "provider_d@msn.com", password: "pw", address: "49 Avenue C, New York, NY 10003", latlong: "40.722237,-73.980501")

contract_a = Contract.create(name: "contract_a", provider_id: provider_a.id, wifi_name: "wifi_a", wifi_password: "pw_a", duration_days: "23", approved: "1", rating: "22")

contract_b = Contract.create(name: "contract_b", provider_id: provider_b.id, wifi_name: "wifi_b", wifi_password: "pw_b", duration_days: "14", approved: "0", rating: "-5")

contract_c = Contract.create(name: "contract_c", provider_id: provider_c.id, wifi_name: "wifi_c", wifi_password: "pw_c", duration_days: "99", approved: "0", rating: "11")

contract_d = Contract.create(name: "contract_d", provider_id: provider_d.id, wifi_name: "wifi_d", wifi_password: "pw_d", duration_days: "31", approved: "1", rating: "0")

admin_a = Admin.create(username: "redblackwrist", password: "seventeenbratwurst")
