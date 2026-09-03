// Qur'an references for the 99 Names of Allah.
// Index 0 = Name #1, index 98 = Name #99.
// Names 1, 2, and 90 use manually supplied references:
// Name 1 = 15:110
// Name 2 = 33:43
// Name 90 = 5:11

const quranReferencesByAllahName = [
  [{ surah: 15, ayah: 110 }], // Name 1
  [{ surah: 33, ayah: 43 }], // Name 2
  [{ surah: 59, ayah: 23 }, { surah: 20, ayah: 114 }, { surah: 23, ayah: 116 }], // Name 3
  [{ surah: 59, ayah: 23 }, { surah: 62, ayah: 1 }], // Name 4
  [{ surah: 59, ayah: 23 }], // Name 5
  [{ surah: 59, ayah: 23 }], // Name 6
  [{ surah: 59, ayah: 23 }], // Name 7
  [{ surah: 3, ayah: 6 }, { surah: 4, ayah: 158 }, { surah: 9, ayah: 40 }, { surah: 48, ayah: 7 }, { surah: 59, ayah: 23 }], // Name 8
  [{ surah: 59, ayah: 23 }], // Name 9
  [{ surah: 59, ayah: 23 }], // Name 10
  [{ surah: 6, ayah: 102 }, { surah: 13, ayah: 16 }, { surah: 36, ayah: 81 }, { surah: 39, ayah: 62 }, { surah: 40, ayah: 62 }, { surah: 59, ayah: 24 }], // Name 11
  [{ surah: 59, ayah: 24 }], // Name 12
  [{ surah: 59, ayah: 24 }], // Name 13
  [{ surah: 20, ayah: 82 }, { surah: 38, ayah: 66 }, { surah: 39, ayah: 5 }, { surah: 40, ayah: 42 }, { surah: 71, ayah: 10 }], // Name 14
  [{ surah: 12, ayah: 39 }, { surah: 13, ayah: 16 }, { surah: 14, ayah: 48 }, { surah: 38, ayah: 65 }, { surah: 39, ayah: 4 }, { surah: 40, ayah: 16 }], // Name 15
  [{ surah: 3, ayah: 18 }, { surah: 38, ayah: 9 }, { surah: 38, ayah: 35 }], // Name 16
  [{ surah: 51, ayah: 58 }], // Name 17
  [{ surah: 34, ayah: 26 }], // Name 18
  [{ surah: 2, ayah: 158 }, { surah: 3, ayah: 92 }, { surah: 4, ayah: 35 }, { surah: 24, ayah: 41 }, { surah: 33, ayah: 40 }], // Name 19
  [{ surah: 2, ayah: 245 }], // Name 20
  [{ surah: 2, ayah: 245 }], // Name 21
  [{ surah: 56, ayah: 3 }], // Name 22
  [{ surah: 58, ayah: 11 }, { surah: 6, ayah: 83 }], // Name 23
  [{ surah: 3, ayah: 26 }], // Name 24
  [{ surah: 3, ayah: 26 }], // Name 25
  [{ surah: 2, ayah: 127 }, { surah: 2, ayah: 256 }, { surah: 8, ayah: 17 }, { surah: 49, ayah: 1 }], // Name 26
  [{ surah: 4, ayah: 58 }, { surah: 17, ayah: 1 }, { surah: 42, ayah: 11 }, { surah: 42, ayah: 27 }], // Name 27
  [{ surah: 22, ayah: 69 }], // Name 28
  [{ surah: 6, ayah: 115 }], // Name 29
  [{ surah: 6, ayah: 103 }, { surah: 22, ayah: 63 }, { surah: 31, ayah: 16 }, { surah: 33, ayah: 34 }], // Name 30
  [{ surah: 6, ayah: 18 }, { surah: 17, ayah: 30 }, { surah: 49, ayah: 13 }, { surah: 59, ayah: 18 }], // Name 31
  [{ surah: 2, ayah: 235 }, { surah: 17, ayah: 44 }, { surah: 22, ayah: 59 }, { surah: 35, ayah: 41 }], // Name 32
  [{ surah: 2, ayah: 255 }, { surah: 42, ayah: 4 }, { surah: 56, ayah: 96 }], // Name 33
  [{ surah: 2, ayah: 173 }, { surah: 8, ayah: 69 }, { surah: 16, ayah: 110 }, { surah: 41, ayah: 32 }], // Name 34
  [{ surah: 35, ayah: 30 }, { surah: 35, ayah: 34 }, { surah: 42, ayah: 23 }, { surah: 64, ayah: 17 }], // Name 35
  [{ surah: 4, ayah: 34 }, { surah: 31, ayah: 30 }, { surah: 42, ayah: 4 }, { surah: 42, ayah: 51 }, { surah: 34, ayah: 23 }], // Name 36
  [{ surah: 13, ayah: 9 }, { surah: 22, ayah: 62 }, { surah: 13, ayah: 30 }, { surah: 34, ayah: 23 }], // Name 37
  [{ surah: 11, ayah: 57 }, { surah: 34, ayah: 21 }, { surah: 42, ayah: 6 }], // Name 38
  [{ surah: 4, ayah: 85 }], // Name 39
  [{ surah: 4, ayah: 6 }, { surah: 4, ayah: 86 }, { surah: 33, ayah: 39 }], // Name 40
  [{ surah: 55, ayah: 27 }, { surah: 7, ayah: 143 }], // Name 41
  [{ surah: 27, ayah: 40 }, { surah: 82, ayah: 6 }], // Name 42
  [{ surah: 4, ayah: 1 }, { surah: 5, ayah: 117 }], // Name 43
  [{ surah: 11, ayah: 61 }], // Name 44
  [{ surah: 2, ayah: 268 }, { surah: 3, ayah: 73 }, { surah: 5, ayah: 54 }], // Name 45
  [{ surah: 31, ayah: 27 }, { surah: 46, ayah: 2 }, { surah: 57, ayah: 1 }, { surah: 66, ayah: 2 }], // Name 46
  [{ surah: 11, ayah: 90 }, { surah: 85, ayah: 14 }], // Name 47
  [{ surah: 11, ayah: 73 }], // Name 48
  [{ surah: 22, ayah: 7 }], // Name 49
  [{ surah: 4, ayah: 166 }, { surah: 22, ayah: 17 }, { surah: 41, ayah: 53 }, { surah: 48, ayah: 28 }], // Name 50
  [{ surah: 6, ayah: 62 }, { surah: 22, ayah: 6 }, { surah: 23, ayah: 116 }, { surah: 24, ayah: 25 }], // Name 51
  [{ surah: 3, ayah: 173 }, { surah: 4, ayah: 171 }, { surah: 28, ayah: 28 }, { surah: 73, ayah: 9 }], // Name 52
  [{ surah: 22, ayah: 40 }, { surah: 22, ayah: 74 }, { surah: 42, ayah: 19 }, { surah: 57, ayah: 25 }], // Name 53
  [{ surah: 51, ayah: 58 }], // Name 54
  [{ surah: 4, ayah: 45 }, { surah: 7, ayah: 196 }, { surah: 42, ayah: 28 }, { surah: 45, ayah: 19 }], // Name 55
  [{ surah: 14, ayah: 8 }, { surah: 31, ayah: 12 }, { surah: 31, ayah: 26 }, { surah: 41, ayah: 42 }], // Name 56
  [{ surah: 72, ayah: 28 }, { surah: 78, ayah: 29 }], // Name 57
  [{ surah: 10, ayah: 34 }, { surah: 27, ayah: 64 }, { surah: 29, ayah: 19 }, { surah: 85, ayah: 13 }], // Name 58
  [{ surah: 10, ayah: 34 }, { surah: 27, ayah: 64 }, { surah: 29, ayah: 19 }, { surah: 85, ayah: 13 }], // Name 59
  [{ surah: 7, ayah: 158 }, { surah: 15, ayah: 23 }, { surah: 30, ayah: 50 }, { surah: 57, ayah: 2 }], // Name 60
  [{ surah: 3, ayah: 156 }, { surah: 7, ayah: 158 }, { surah: 15, ayah: 23 }, { surah: 57, ayah: 2 }], // Name 61
  [{ surah: 2, ayah: 255 }, { surah: 3, ayah: 2 }, { surah: 20, ayah: 111 }, { surah: 25, ayah: 58 }, { surah: 40, ayah: 65 }], // Name 62
  [{ surah: 2, ayah: 255 }, { surah: 3, ayah: 2 }, { surah: 20, ayah: 111 }], // Name 63
  [{ surah: 38, ayah: 44 }], // Name 64
  [{ surah: 85, ayah: 15 }, { surah: 11, ayah: 73 }], // Name 65
  [{ surah: 13, ayah: 16 }, { surah: 14, ayah: 48 }, { surah: 38, ayah: 65 }, { surah: 39, ayah: 4 }], // Name 66
  [{ surah: 112, ayah: 1 }], // Name 67
  [{ surah: 112, ayah: 2 }], // Name 68
  [{ surah: 6, ayah: 65 }, { surah: 46, ayah: 33 }, { surah: 75, ayah: 40 }], // Name 69
  [{ surah: 18, ayah: 45 }, { surah: 54, ayah: 42 }, { surah: 6, ayah: 65 }], // Name 70
  [{ surah: 16, ayah: 61 }], // Name 71
  [{ surah: 71, ayah: 4 }], // Name 72
  [{ surah: 57, ayah: 3 }], // Name 73
  [{ surah: 57, ayah: 3 }], // Name 74
  [{ surah: 57, ayah: 3 }], // Name 75
  [{ surah: 57, ayah: 3 }], // Name 76
  [{ surah: 13, ayah: 11 }], // Name 77
  [{ surah: 13, ayah: 9 }], // Name 78
  [{ surah: 52, ayah: 28 }], // Name 79
  [{ surah: 2, ayah: 128 }, { surah: 4, ayah: 64 }, { surah: 49, ayah: 12 }, { surah: 110, ayah: 3 }], // Name 80
  [{ surah: 32, ayah: 22 }, { surah: 43, ayah: 41 }, { surah: 44, ayah: 16 }], // Name 81
  [{ surah: 4, ayah: 43 }, { surah: 4, ayah: 99 }, { surah: 4, ayah: 149 }, { surah: 22, ayah: 60 }, { surah: 58, ayah: 2 }], // Name 82
  [{ surah: 3, ayah: 30 }, { surah: 9, ayah: 117 }, { surah: 57, ayah: 9 }, { surah: 59, ayah: 10 }], // Name 83
  [{ surah: 3, ayah: 26 }], // Name 84
  [{ surah: 55, ayah: 27 }, { surah: 55, ayah: 78 }], // Name 85
  [{ surah: 7, ayah: 29 }, { surah: 3, ayah: 18 }], // Name 86
  [{ surah: 3, ayah: 9 }], // Name 87
  [{ surah: 3, ayah: 97 }, { surah: 39, ayah: 7 }, { surah: 47, ayah: 38 }, { surah: 57, ayah: 24 }], // Name 88
  [{ surah: 9, ayah: 28 }], // Name 89

  // Manually supplied reference
  [{ surah: 5, ayah: 11 }], // Name 90

  [{ surah: 6, ayah: 17 }], // Name 91
  [{ surah: 30, ayah: 37 }], // Name 92
  [{ surah: 24, ayah: 35 }], // Name 93
  [{ surah: 22, ayah: 54 }], // Name 94
  [{ surah: 2, ayah: 117 }, { surah: 6, ayah: 101 }], // Name 95
  [{ surah: 55, ayah: 27 }], // Name 96
  [{ surah: 15, ayah: 23 }, { surah: 57, ayah: 10 }], // Name 97
  [{ surah: 2, ayah: 256 }, { surah: 72, ayah: 10 }], // Name 98
  [{ surah: 2, ayah: 153 }, { surah: 3, ayah: 200 }, { surah: 103, ayah: 3 }], // Name 99
];

// Example:
// const refs = quranReferencesByAllahName[nameIndex];
// refs.forEach(({ surah, ayah }) => {
//   loadAyahFromIntegratedQuran(surah, ayah);
// });