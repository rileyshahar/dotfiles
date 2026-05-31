/// <reference types="@raycast/api">

/* 🚧 🚧 🚧
 * This file is auto-generated from the extension's manifest.
 * Do not modify manually. Instead, update the `package.json` file.
 * 🚧 🚧 🚧 */

/* eslint-disable @typescript-eslint/ban-types */

type ExtensionPreferences = {}

/** Preferences accessible in all the extension's commands */
declare type Preferences = ExtensionPreferences

declare namespace Preferences {
  /** Preferences accessible in the `eb-minutes` command */
  export type EbMinutes = ExtensionPreferences & {}
  /** Preferences accessible in the `department-lists` command */
  export type DepartmentLists = ExtensionPreferences & {}
  /** Preferences accessible in the `building-lists` command */
  export type BuildingLists = ExtensionPreferences & {}
  /** Preferences accessible in the `oc-meeting-notes` command */
  export type OcMeetingNotes = ExtensionPreferences & {}
}

declare namespace Arguments {
  /** Arguments passed to the `eb-minutes` command */
  export type EbMinutes = {}
  /** Arguments passed to the `department-lists` command */
  export type DepartmentLists = {}
  /** Arguments passed to the `building-lists` command */
  export type BuildingLists = {}
  /** Arguments passed to the `oc-meeting-notes` command */
  export type OcMeetingNotes = {}
}

