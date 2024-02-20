import { Controller } from "@hotwired/stimulus";

const options = {
  enableHighAccuracy: true,
  maximumAge: 0,
};

// Connects to data-controller="geolocation"
export default class extends Controller {
  static values = { url: String };

  search() {
    navigator.geoLocation.getCurrentPosition(
      this.success.bind(this),
      this.error,
      options,
    );
  }

  success(position) {
    const coordinates = position.coords;
    location.assign(
      `/locations/?place=${coordinates.latitude},${coordinates.longitude}`,
    );
  }

  error(err) {
    console.warn(`ERROR(${err.code}): ${err.message}`);
  }
}
