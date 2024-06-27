# Gerador de card com Nome e QRCODE

Feito em bash para facilitar a vida de um projeto que precisava imprimir o nome de pessoas com um qrcode abaixo do nome. 
Tive ajuda do GPT4.0 para os comandos com Imagemagick, que é treta. 

1. Arquivo de Dados usado:

O arquivo `Book1.csv` com a estrutura abaixo, para gerar cards com qrcodes imprimiveis:

```text
Nome da Pessoa,QRCODEID
Nome de outra Pessoa,BLABLA
```

2. Codigo bash, depende do Imagemagick

Nome: `script.sh`

```bash
#!/bin/bash

# Parâmetros de entrada
NAME=$(echo $1 | cut -d',' -f1)
CODE=$(echo $1 | cut -d',' -f2)

OUTPUT_FILE=$(echo $NAME | sed -e 's/\ /-/g')

# Gerar QR code
QR_FILE="${OUTPUT_FILE}_qrcode.png"
BG_FILE="${OUTPUT_FILE}_background.png"
TX_FILE="${OUTPUT_FILE}_text_image.png"
qrencode -o $QR_FILE -s 10 -v 1 -m 2 -l m "$CODE"

# Dimensões da imagem final
WIDTH=600
HEIGHT=400

# Criar imagem branca de fundo
convert -size ${WIDTH}x${HEIGHT} canvas:white $BG_FILE 
# Adicionar o nome na imagem
convert $BG_FILE -gravity north -pointsize 24 -annotate +0+50 "$NAME" $TX_FILE 

# Adicionar o QR code na imagem
QR_X=$(( (WIDTH - 200) / 2 ))
QR_Y=$(( 100 + 20 ))
convert $TX_FILE $QR_FILE -geometry +${QR_X}+${QR_Y} -composite "page_${OUTPUT_FILE}.png"

# Limpeza
rm $QR_FILE $BG_FILE $TX_FILE

echo "Imagem gerada em $OUTPUT_FILE.png"
```

3. Para gerar as imagens à partir do arquivo `Book1.csv`:

```bash
while read line; do ./script.sh $line ; done < Book1.csv
```

4. Para juntar as imagens tudo em um arquivo só:

```bash
montage -mode concatenate -geometry +0+0 page_*.png -resize 600x400 -extent 600x400 -tile 3x3 -gravity center -page a3 test.png
```

