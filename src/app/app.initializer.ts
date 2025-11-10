import { inject } from "@angular/core";
import { ConfigService } from "./config.service";

export function appInitializer(): () => Promise<any> {
  const configService = inject(ConfigService);
  return () => configService.loadConfig();
}
