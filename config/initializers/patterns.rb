PATTERNS = {
  mini: /^mini/i,
  sedan: /^sedan/i,
  yes: /^yes/i,
  no: /^no/i,
  book_in: /book.*in(.*\d?) (.*\w?)/i,
  book_at: /book.*at(.*\d?) (.*\w?)/i,
  estimate: /from (.*\w?) to (.*\w?)/i,
  driver_location: /driver.*loca/i,
}

REDIS = Redis.new(host: '127.0.0.1', port: 6379, db: 3)