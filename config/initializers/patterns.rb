PATTERNS = {
  mini: /^(mini|:car:)/i,
  sedan: /^(sedan|:taxi:)/i,
  yes: /^(yes|:thumbsup:)/i,
  no: /^(no|:thumbsdown:)/i,
  book_in: /book.*in(.*\d?) (.*\w?)/i,
  book_at: /book.*at(.*\d?) (.*\w?)/i,
  estimate: /from (.*\w?) to (.*\w?)/i,
  driver_location: /(driver.*loca|where.*driv)/i,
}

REDIS = Redis.new(host: '127.0.0.1', port: 6379, db: 3)