class Quote {
  final String text;
  final String author;

  const Quote(this.text, {this.author = ''});
}

class QuotesDatabase {
  static const List<Quote> matrixQuotes = [
    Quote('Wake up, Neo...'),
    Quote('The Matrix has you...'),
    Quote('Follow the white rabbit.'),
    Quote('Knock, knock, Neo.'),
    Quote('There is no spoon.'),
    Quote('I know kung fu.'),
    Quote('Free your mind.'),
    Quote('Unfortunately, no one can be told what the Matrix is. You have to see it for yourself.'),
    Quote('Welcome to the real world.'),
    Quote('What is real? How do you define real?'),
    Quote('I can only show you the door. You have to walk through it.'),
    Quote('Choice is an illusion created between those with power and those without.'),
    Quote('You are a slave, Neo. Like everyone else, you were born into bondage.'),
    Quote('The Matrix is everywhere. It is all around us.'),
    Quote('Denial is the most predictable of all human responses.'),
    Quote('Never send a human to do a machine\'s job.'),
    Quote('The problem is choice.'),
    Quote('Everything that has a beginning has an end.'),
    Quote('Because I choose to.'),
    Quote('You don\'t know what\'s possible until you try.'),
    Quote('We are here to help you become what you were meant to be.'),
    Quote('The body cannot live without the mind.'),
    Quote('There\'s a difference between knowing the path and walking the path.'),
    Quote('To deny our own impulses is to deny the very thing that makes us human.'),
  ];

  static const List<Quote> motivationalQuotes = [
    Quote('Sen dunyoni o\'zgartirishing kerak!'),
    Quote('Uyg\'on! Vaqt keldi!'),
    Quote('Har bir kun yangi imkoniyat.'),
    Quote('Bugun o\'zgarishni boshlash uchun eng yaxshi kun.'),
    Quote('Sen cheksiz imkoniyatlarga egasan.'),
    Quote('Orzularing sari bir qadam tashla.'),
    Quote('Muvaffaqiyat - bu odat.'),
    Quote('Kuch sening ichingda.'),
    Quote('Tush kutmaydi, sen uni quvishing kerak.'),
    Quote('Hech qachon kech emas.'),
    Quote('Imkoniyatlar cheksiz.'),
    Quote('Bugun sen eng yaxshi versiyang bo\'l.'),
    Quote('Har bir qiyinchilik yangi imkoniyatdir.'),
    Quote('Sen o\'ylagandan ham kuchlisan.'),
    Quote('Intizom - bu erkinlik.'),
    Quote('Harakat qil, xato qil, yana urinib ko\'r.'),
    Quote('Eng katta xavf - hech qanday xavfni olmaslik.'),
    Quote('Vaqt keldi. Hozir. Aynan shu dam.'),
    Quote('Uyg\'on va dunyoni larzaga keltir!'),
    Quote('Sen tanlagan yo\'l - sening yo\'ling.'),
    Quote('Kodni o\'zgartir, olamni o\'zgartir.'),
    Quote('Real hayot - bu sen yaratgan hayot.'),
    Quote('Chegaralar faqat boshingda.'),
    Quote('O\'z taqdiringni o\'zing yoz.'),
  ];

  static List<Quote> get all => [...matrixQuotes, ...motivationalQuotes];

  static Quote getRandom() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return all[random % all.length];
  }

  static Quote getRandomMatrix() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return matrixQuotes[random % matrixQuotes.length];
  }

  static Quote getRandomMotivational() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return motivationalQuotes[random % motivationalQuotes.length];
  }
}
