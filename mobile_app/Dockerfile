FROM cirrusci/flutter:stable

WORKDIR /app

COPY pubspec.* ./
RUN flutter pub get

COPY . .

RUN flutter build apk --release

CMD ["flutter", "run", "--release"]