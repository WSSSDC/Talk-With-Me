class Categories {
  static List<Category> groups = [
    Category()
    ..name = 'Relationships'
    ..items = [
      TalkingItem()
      ..name = 'Family'
      ..userPrompt = "I'm having issues with my family"
      ..aiPrompt = "Can you tell me more about the issues you're having with your family?",
      TalkingItem()
      ..name = 'Breakup'
      ..userPrompt = "I'm just went through a hard breakup",
      TalkingItem()
      ..name = 'Issues with Partner'
      ..userPrompt = "I'm having issues with my partner",
    ],
    Category()
    ..name = 'Condition'
    ..items = [
      TalkingItem()
      ..name = 'Mood Swings'
      ..userPrompt = "I've been having mood swings",
      TalkingItem()
      ..name = 'Depression'
      ..userPrompt = "I've been depressed lately",
      TalkingItem()
      ..name = 'Anxiety'
      ..userPrompt = "I've had anxiety recently",
      TalkingItem()
      ..name = 'Stress'
      ..userPrompt = "I've been stressed out"
    ],
    Category()
    ..name = 'Work & Career'
    ..items = [
      TalkingItem()
      ..name = 'Stress'
      ..userPrompt = "I've been having trouble with stress at work",
      TalkingItem()
      ..name = 'Lack of purpose'
      ..userPrompt = "I've feel like my job doesn't give me a purpose",
      TalkingItem()
      ..name = 'Layoff'
      ..userPrompt = "I was recently fired"
    ],
  ];
}

class Category {
  String name;
  List<TalkingItem> items = [];
}

class TalkingItem {
  String name = '';
  String userPrompt = '';
  String aiPrompt = 'Can you talk about that?';
}