class Rating {
  final String id;
  final String jobId;
  final int score;
  final String reviewerId;
  final String reviewedId;
  final String reviewedType;
  final String comment;

  const Rating({
    required this.id,
    required this.jobId,
    required this.score,
    required this.reviewerId,
    required this.reviewedId,
    required this.reviewedType, 
    required this.comment
  });

  factory Rating.fromFirestore(Map<String, dynamic> map) {
    return Rating(
      id: map['id'] as String,
      jobId: map['jobId'] as String,
      score: map['score'] as int,
      reviewerId: map['reviewerId'] as String,
      reviewedId: map['reviewedId'] as String,
      reviewedType: map['reviewedType'] as String,
      comment: map['comment'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'jobId': jobId,
      'score': score,
      'reviewerId': reviewerId,
      'reviewedId': reviewedId,
      'reviewedType': reviewedType,
      'comment': comment,
    };
  }
}