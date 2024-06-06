use actix_web::{get, App, HttpServer, Responder};

#[get("/")]
async fn hello() -> impl Responder {
    "Hello, world!!!"
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let mut addrs = "0.0.0.0:8080";
    if cfg!(debug_assertions) {
        addrs = "127.0.0.1:8080";
    }

    HttpServer::new(|| App::new().service(hello))
        .bind(addrs)?
        .run()
        .await
}
