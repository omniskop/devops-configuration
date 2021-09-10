module.exports = {
    apps : [
        {
            name: "app-server",
            script: "/home/{{ ansible_user_id }}/deployment/app/server/src/index.js",
            out_file: "/home/{{ ansible_user_id }}/output.log",
            err_file: "/home/{{ ansible_user_id }}/error.log",
            log_file: "/home/{{ ansible_user_id }}/server.log",
            env: {
                "NODE_ENV": "production",
                "PORT": "{{ app_server_port }}",
                "CLIENT_URL": "http://{{ balancer_server_ip_address }}:80",
                "MONGODB_URL": "mongodb://{{ app_database_vpc_ip_address }}:27017/todo-app",
                "JWT_SECRET": "{{ jwt_secret }}"
            }
        }
    ]
  }