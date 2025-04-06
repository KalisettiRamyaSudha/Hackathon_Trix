Project Title: Invision - Indoor Navigation App for Disabled People

Team Name: Trix

Team Members:

Pavan Yarlagadda - Masters in Computer Science
Jahnavi Chintakindi - Masters in Data Science
Panam Dodia - Masters in Artificial Intelligence
Ramya Sudha Kalisetti - Masters in Computer Science
Vamsee Yalla - Masters in Computer Science

GradinnoHack Table Choices:


Tech & Skills: Mobile/Web Development
Impact Area: Accessibility, Equity & Inclusion
User Group: People with Disabilities

Problem Statement
Disabled people face significant challenges when navigating indoor environments such as complex buildings. Traditional navigation tools often fail to provide accessible routes or detailed information about indoor facilities necessary for people with disabilities.

Proposed Solution
Our application is a specialized indoor navigation tool that provides the best possible route to destinations within buildings through voice or text interfaces. The app offers critical accessibility details such as nearest elevators, ramp locations, and open areas to ensure barrier-free navigation.

Implementation

We have taken the first floor blueprint of Discovery Park , and provided it with a flutter framework to map the hallways, elevators and stairs. 

Tech Stack:
Phone: Android/iOS with Wi-Fi capability.
Development: Flutter (cross-platform, fast prototyping).
Mapbox: For rendering the custom map.
Wi-Fi Scanning: Use Flutter’s wifi_scan package to detect AP signals.



 Impact

Societal Benefits
This Wi-Fi-based indoor navigation MVP lays the groundwork for a transformative tool designed to empower people with disabilities in navigating indoor spaces. Built for a single building using only a smartphone and its existing Wi-Fi access points, it offers a low-cost, accessible starting point for individuals who face mobility, visual, or cognitive challenges. 

Next Steps
Within the current scope— a single-building prototype with basic Wi-Fi fingerprinting—the next steps focus on stabilizing this MVP and preparing it for disability-specific enhancements. We’ll refine location accuracy (currently 5-15 meters) by optimizing the fingerprint-matching algorithm and adding a manual reset option to correct drift, ensuring reliability for users who depend on consistent guidance. Testing with real users in the target building will reveal practical pain points, especially for those with disabilities. From there, we’ll begin designing tailored features—such as voice output for the visually impaired, simplified routes for cognitive support, or vibration cues for the hearing impaired—building on this core system. Expanding the map to include multi-floor support and integrating user feedback will set the stage for a disability-focused tool that meets diverse needs.
Scalability
This MVP targets one building, but its disability-driven purpose and no-hardware approach make it highly scalable. The use of existing Wi-Fi and a digitized blueprint means it can be adapted to other small, Wi-Fi-equipped facilities—like community centers, clinics, or schools—by simply mapping their layouts and collecting fingerprints. The Flutter-based app runs on most smartphones, ensuring broad accessibility for users with disabilities across socioeconomic backgrounds. Within the building, scaling involves adding more fingerprint points for finer location granularity, critical for precise navigation assistance. As we develop disability-specific features, this framework could become a customizable template for other spaces, offering a scalable, low-cost solution that prioritizes inclusivity and adapts to varied accessibility needs with minimal setup.

This version emphasizes the app’s disability-focused mission while staying true to its current scope (basic functionality, single building, no hardware). It highlights the societal value for people with disabilities and positions future feature additions as the next logical step. 









