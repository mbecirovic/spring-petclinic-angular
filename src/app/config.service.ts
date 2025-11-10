import { Injectable } from "@angular/core";

@Injectable({
  providedIn: "root",
})
export class ConfigService {
  private config: any;

  constructor() {}

  loadConfig(): Promise<any> {
    return fetch("/assets/config/config.json")
      .then((response) => response.json())
      .then((data) => {
        this.config = data;
        return data;
      });
  }

  getConfig(key: string): any {
    return this.config ? this.config[key] : null;
  }
}
