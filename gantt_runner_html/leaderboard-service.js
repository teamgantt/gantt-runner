const supabaseUrl = "https://vmcvbmsqecjniofsxvbk.supabase.co";
const supabaseKey =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZtY3ZibXNxZWNqbmlvZnN4dmJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTU4Njg1MjQsImV4cCI6MjAxMTQ0NDUyNH0.zwnGupALM45DB3g1a0msclVbHv07x0J4bmL9qPcf0J0";
const supabase = window.supabase.createClient(supabaseUrl, supabaseKey);

const LEVELS = {
  1: "54a4a44e-8355-4681-9c03-0869d918c272",
  2: "d2d2448b-d1a3-4e10-bba4-41e81b854dc6",
  3: "866f1a67-b0ba-4665-97c9-8fdf39571754",
};

export async function isHighScore(level, score) {
  const results = await getScores(level);

  return results.length < 10 || results.some((result) => score > result.score);
}

export async function submitScore(level, { name, score, character, time }) {
  const leaderboard_id = LEVELS[level];
  const { error } = await supabase
    .from("scores")
    .insert({ name, score, leaderboard_id, extra_data: { character, time } });

  if (error) {
    throw new Error(error.message);
  }
}

export async function getScores(levelNumber) {
  const leaderboardId = LEVELS[levelNumber];
  const response = await supabase
    .from("scores")
    .select()
    .eq("leaderboard_id", leaderboardId)
    .order("score", { ascending: false })
    .limit(10);

  return response.data.map((x) => ({
    score: x.score,
    name: x.name,
    character: x.extra_data.character,
    time: x.extra_data.time,
  }));
}
