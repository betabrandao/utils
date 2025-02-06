
options.timeout = 120
options.subscribe = true

-- get password to passwordstore
status, password = pipe_from('pass mail.com/user@mail.com | grep device_password | cut -d: -f2')
local password = password:gsub('[\r\n]', '')

local account = IMAP {
    server = 'imap.mail.com',
    username = 'user@mail.com',
   -- password = 'mailpassword',
    password = password,
    ssl = 'tls1'
}

-- function remove_accents(str)
--     local accents = {
--         ["á"]="a", ["à"]="a", ["ã"]="a", ["â"]="a", ["ä"]="a",
--         ["é"]="e", ["è"]="e", ["ê"]="e", ["ë"]="e",
--         ["í"]="i", ["ì"]="i", ["î"]="i", ["ï"]="i",
--         ["ó"]="o", ["ò"]="o", ["õ"]="o", ["ô"]="o", ["ö"]="o",
--         ["ú"]="u", ["ù"]="u", ["û"]="u", ["ü"]="u",
--         ["ç"]="c", ["ñ"]="n"
--     }
--     return str:gsub("[áàãâäéèêëíìîïóòõôöúùûüçñ]", accents)
-- end

-- Lista de palavras-chave no assunto que serão deletadas
local keywords = {
  "treinamento",
  "oportunidade",
  "plano",
  "saude",
  "formacao",
  "protecao",
  "holding",
  "produto",
  "oferta",
  "ofertas",
  "produtos",
  "idiomas",
  "massageador",
  "churrasco",
  "travesseiro"}

-- Lista de domínios considerados spam (case-insensitive)
local spam_domains = {
  "sulamerica.com.br",
  "santalolla.com.br",
  "maxempresarial.com.br",
  "mixupoportunidades.com.br",
  "web-mail.agency",
  "openmate.sbs",
  "xump.tienda",
  "pillingers.de",
  "qualyden.com.br",
  "nettmkt.com.br",
  "unidas.com.br"
}

-- Mover para Spam email com usuarios com hifens, com o padrao do serviço de spam
-- com o template aaaaa-a00@mail.com
local emailsc = account.INBOX:match_from("[a-zA-Z]+-[a-zA-Z0-9]+")
emailsc:move_messages(account["Junk"])


-- Filtrar e excluir emails com essas palavras no assunto
for _, word in ipairs(keywords) do
--  local normalized_word = remove_accents(word)  -- teste
    local emails = account.INBOX:match_subject("(?i)" .. word)
    emails:delete_messages()
end

-- Mover para SPAM emails de domínios indesejados (sem case-sensitive)
for _, domain in ipairs(spam_domains) do
    local emailsd = account.INBOX:match_from("(?i).*@*" .. domain)  -- (?i) ignora maiúsculas e minúsculas
    emailsd:move_messages(account["Junk"])
end

