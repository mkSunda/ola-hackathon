# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :redis_session_store, {
  key: '_scond_session',
  redis: {
    db: 2,
    expire_after: 120.minutes,
    key_prefix: 'myapp:session:',
  }
}