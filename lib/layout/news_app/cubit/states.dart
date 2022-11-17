abstract class NewsState {}

class NewsInitialState extends NewsState{}

class NewsBottomNavState extends NewsState{}

class NewsChangeBottomNavState extends NewsState{}

class NewsLoadingState extends NewsState{}

class NewsGetBusinessSuccessStste extends NewsState{}

class NewsGetBusinessErrorStste extends NewsState{
  final String error;

  NewsGetBusinessErrorStste(this.error);
}

class NewsLoadingSportsState extends NewsState{}

class NewsGetSoprtsSuccessStste extends NewsState{}

class NewsGetSportsErrorStste extends NewsState{
  final String error;

  NewsGetSportsErrorStste(this.error);
}


class NewsLoadingScienceState extends NewsState{}

class NewsGetSciencSuccessStste extends NewsState{}

class NewsGetScienceErrorStste extends NewsState{
  final String error;

  NewsGetScienceErrorStste(this.error);
}



class NewsLoadingSearchState extends NewsState{}

class NewsGetSearchSearchStste extends NewsState{}

class NewsGetSearchErrorStste extends NewsState
{
  final String error;


  NewsGetSearchErrorStste(this.error);
}