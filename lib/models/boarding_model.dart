class BoardingModel {
  final String image;
  final String title;
  final String subTitle;

  BoardingModel(
      {required this.image, required this.title, required this.subTitle});
}

final List<BoardingModel> boardings = [
  BoardingModel(image: '', title: 'Page One', subTitle: 'Page One subTitle'),
  BoardingModel(image: '', title: 'Page Two', subTitle: 'Page Two subTitle'),
  BoardingModel(image: '', title: 'Page Three', subTitle: 'Page Three subTitle'),
];
