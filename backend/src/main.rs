use actix_web::{web, App, HttpServer, Responder};
use serde::{Deserialize, Serialize};
use dotenv::dotenv;
use std::env;

#[derive(Serialize, Deserialize)]
struct User {
    id: i32,
    username: String,
    email: String,
    balance: f64,
}

async fn get_user() -> impl Responder {
    // Mock user data, replace with database query later
    let user = User {
        id: 1,
        username: "johndoe".to_string(),
        email: "johndoe@example.com".to_string(),
        balance: 10000.0,
    };
    web::Json(user)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();

    let port = env::var("RUST_BACKEND_PORT").unwrap_or_else(|_| "8081".to_string());
    let address = format!("127.0.0.1:{}", port);

    HttpServer::new(|| {
        App::new()
            .route("/api/user", web::get().to(get_user))
    })
    .bind(address)?
    .run()
    .await
}