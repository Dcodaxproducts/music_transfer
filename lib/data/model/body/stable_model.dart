class StableBody {
  // The API key of stable diffusion
  final String apiKey;

  // Text prompt with description of the things you want in the image to be generated
  final String prompt;

  // Items you don't want in the image
  final String negativePrompt;

  // The width of the image to be generated (Max Height: Width: 1024x1024)
  final String width;

  // The height of the image to be generated (Max Height: Width: 1024x1024)
  final String height;

  // Number of images to be returned in response. The maximum value is 4.
  final String samples;

  // A checker for NSFW images. If such an image is detected, it will be replaced by a blank image.
  final bool saftey;

  // Enhance prompts for better results; default: yes, options: yes/no
  final bool enhancePrompt;

  // Scale for classifier-free guidance (minimum: 1; maximum: 20)
  final double guidanceScale;

  // Allow multi lingual prompt to generate images. Set this to "yes" if you use a language different from English in your text prompts.
  final String langauge;

  // Set this parameter to "yes" to generate a panorama image.
  final bool panorama;

  // Set this parameter to "2" if you want to upscale the given image resolution two times (2x), options:: 1, 2, 3
  final bool upscale;

  // The id of the model.
  final String model;

  //Number of denoising steps. The value accepts 21,31,41 and 51
  final int steps;

  // If you want a high quality image, set this parameter to "yes". In this case the image generation will take more time.
  final bool selfAttention;

  // Seed is used to reproduce results, same seed will give you same image in return again. Pass null for a random number.
  final int? seed;

  // highres fix for generated image, default: "no", options: yes/no
  final bool faceFix;

  StableBody({
    required this.apiKey,
    required this.prompt,
    required this.negativePrompt,
    required this.width,
    required this.height,
    required this.samples,
    required this.saftey,
    required this.enhancePrompt,
    required this.guidanceScale,
    required this.langauge,
    required this.panorama,
    required this.upscale,
    required this.model,
    required this.steps,
    required this.selfAttention,
    required this.seed,
    required this.faceFix,
  });

  // to json
  Map<String, dynamic> toJson() {
    bool anything = model.startsWith('https');
    var map = <String, dynamic>{
      'key': apiKey,
      'prompt': prompt,
      'negative_prompt': negativePrompt,
      'width': width,
      'height': height,
      'samples': samples,
      "num_inference_steps": steps.toString(),
      'safety_checker':
          saftey ? (anything ? true : 'yes') : (anything ? false : 'no'),
      'safety_checker_type': 'black',
      'enhance_prompt': enhancePrompt ? true : false,
      'guidance_scale': guidanceScale,
      'multi_lingual': langauge == 'en_XX' ? 'no' : 'yes',
      'panorama': panorama ? 'yes' : 'no',
      'upscale': (upscale ? '2' : '1'),
      'self_attention': !selfAttention ? 'no' : 'yes',
      "seed": seed?.toString(),
      "webhook": null,
      "track_id": null,
      'model_id': model,
      "tomesd": 'yes',
      "use_karras_sigmas": 'yes',
      "highres_fix": faceFix ? 'yes' : 'no',
    };

    return map;
  }
}
