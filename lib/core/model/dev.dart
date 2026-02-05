enum Env { dev, prod }

class Environment {
  // TODO: change to prod before release
  static Env environment = Env.prod;

  static bool get isDev => environment == Env.dev;
  static bool get isProd => environment == Env.prod;
}
