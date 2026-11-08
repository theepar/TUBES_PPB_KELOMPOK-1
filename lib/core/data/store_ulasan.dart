part of 'demo_store.dart';

extension DemoStoreUlasan on DemoStore {
  void simpanUlasan(
    String talentId,
    int rating,
    String komentar, {
    String? id,
  }) {
    if (!isPencari || rating < 1 || rating > 5 || komentar.trim().isEmpty) {
      throw StateError('Isi bintang dan komentar');
    }
    final i = reviews.indexWhere((r) => r.id == id);
    if (id != null && (i < 0 || reviews[i].userId != _userId)) {
      throw StateError('Ulasan bukan milik Anda');
    }
    final review = Ulasan(
      id: id ?? idBaru('review'),
      talentId: talentId,
      userId: _userId!,
      rating: rating,
      komentar: komentar.trim(),
    );
    if (i < 0) {
      reviews.insert(0, review);
    } else {
      reviews[i] = review;
    }
    _hitungRating(talentId);
    refresh();
  }

  void hapusUlasan(Ulasan review) {
    if (review.userId != _userId) throw StateError('Ulasan bukan milik Anda');
    reviews.remove(review);
    _hitungRating(review.talentId);
    refresh();
  }
}
