# **Anecdote**

**Anecdote** is a Ruby on Rails-based **social** media platform designed to foster **collaborative** **memory** sharing among friends. Unlike traditional social media that emphasizes following celebrities or influencers, **Anecdote** is all about **connecting** with your friends and collectively creating and sharing stories, photos, and experiences. Whether it's sharing **funny** anecdotes from a recent vacation, documenting life events, or simply keeping up with each other’s daily lives, **Anecdote** makes it easy and fun.

## Features

### 1. **User Authentication**
   - **Sign Up and Log In:** Users can register, log in, and manage their accounts securely using the Devise gem.
   - **Profile Management:** Users can update their profile information, including a profile picture and biography, to personalize their experience.

### 2. **Posts**
   - **Create and Edit Posts:** Users can create posts to share their stories, experiences, and thoughts. Posts can be edited or deleted as needed.
   - **Multimedia Support:** Attach images to posts to visually enrich your stories and experiences.
   - **Post Organization:** Posts are displayed in reverse chronological order, making it easy to stay updated on the latest content.

### 3. **Comments and Likes**
   - **Interactive Content:** Users can comment on posts to engage in conversations, share feedback, or add their own anecdotes.
   - **Liking Posts:** Users can like posts to show their appreciation for the shared content.

### 4. **Friendships**
   - **Friend Requests:** Users can send and accept friend requests to connect with others on the platform.
   - **Symmetrical Friendships:** Once a friend request is accepted, both users become friends, allowing them to see and interact with each other's content.
   - **Manage Friendships:** Users can view their friends list, remove friends, and manage their connections from their profile.

### 5. **Collaborative Memory Sharing** (In Work)
   - **Group Posts:** Users can collaborate with friends to create shared posts, contributing to a collective memory or experience.
   - **Storytelling:** Encourage group participation in telling stories by allowing multiple users to add content to a single post.

### 6. **Responsive Design**
   - **User-Friendly Interface:** Anecdote is designed to be responsive, providing an optimal viewing experience across a wide range of devices in the web, from mobile phones to desktop computers.

### 7. **Notifications (Planned)**
   - **Stay Informed:** Future updates will include notifications to keep users informed of new friend requests, comments, and likes on their posts.

## Getting Started

### Why Ruby On Rails?
**Ruby on Rails excels in web development with the following features:**
- **MVC Architecture**: Separates concerns into Models (data), Views (UI), and Controllers (logic), promoting clean code and easier maintenance.
- **Active Record**: Simplifies database integration by allowing interactions with database records as Ruby objects, enhancing data management and reducing boilerplate code.
- **ERB Templates**: Embeds Ruby code into HTML, enabling dynamic content generation within views.
- **SCSS**: Provides advanced styling capabilities, making it easy to create responsive and visually appealing designs.
- **Convention Over Configuration**: Reduces decision-making and setup time with sensible defaults, accelerating development.


### Prerequisites

- **Ruby:** Version 3.x or higher
- **Rails:** Version 6.x or higher
- **SQLite3:** Used as the database in development

### To get started with this project:

1. **Clone the Repository:**
   `git clone https://github.com/JakubSchwenkbeck/Social-Media/.git`
2. **Navigate to the Root Directory:**
   `cd Anecdote `
3. **Run the App** Use `rails server` to put up a local server accessible by visiting http://localhost:3000/.
