PATTERNS = {
  mini: /^(mini|:car:)/i,
  sedan: /^(sedan|:taxi:)/i,
  yes: /^(yes|:thumbsup:|:+1:|yea)/i,
  no: /^(no|:thumbsdown:)/i,
  book_in: /book.*in(.*\d?) (.*\w?)/i,
  book_at: /book.*at(.*\d?) (.*\w?)/i,
  estimate: /from (.*\w?) to (.*\w?)/i,
  driver_location: /(driv.*loca|wher.*driv)/i,
}

REDIS = Redis.new(host: '127.0.0.1', port: 6379, db: 3)