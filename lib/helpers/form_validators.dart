String emailKontrol(String mail) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(mail))
    return 'Geçerli bir mail giriniz';
  else
    return null;
}

String sifreKontrol(String girilenDeger) {
  if (girilenDeger.length < 6) {
    return "Şifreniz en az 6 karakterden oluşmalıdır";
  } else {
    return null;
  }
}
