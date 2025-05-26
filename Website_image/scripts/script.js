const APIKEY = '51b70285'; 
const latestReleaseContainer = document.getElementById('latestReleaseContainer');
const noResultContainer = document.getElementById('noResultContainer');
const noResultMsg = document.getElementById('noResultMsg');
const moviesContainer = document.getElementById('moviesContainer');
const movieSection = document.getElementById('movieSection');
const movieLine = document.getElementById('movieLine');
const showsContainer = document.getElementById('showsContainer');
const showSection = document.getElementById('showSection');
const showLine = document.getElementById('showLine');
const favoriteContainer = document.getElementById('favoriteContainer');
const favoriteSection = document.getElementById('favoriteSection');
const searchInput = document.getElementById('search');

// Array to store favorite movies/shows
let favorites = [];

// Default fetch
async function defultFetch(){
    const now = new Date();
    const currentYear = now.getFullYear();
    // console.log(currentYear);
    const url = `http://www.omdbapi.com/?s=action&y=${currentYear}&apikey=${APIKEY}`;
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json()
        latestReleaseContainer.innerHTML = '';
        const mediaItems = data.Search;

            await Promise.all(mediaItems.map(async (item) => { // use await here
            const ratingData = await fetchRating(item.Title);
            item.imdbRating = ratingData.imdbRating;
        }));

        mediaItems.forEach(media => {
            const card = createMediaCard(media);
            latestReleaseContainer.appendChild(card);
        });
    } catch (error) {
        console.error('Fetch error:', error);
        displayMessage(`Error: ${error.message}`);
        throw error; // Re-throw to be caught by caller
    }
}
defultFetch();

// Helper function to create a movie/show card
function createMediaCard(media, showIcon = true) {
    const card = document.createElement('div');
    card.className = 'col-lg-3 col-md-6 mb-3 main-card custom-card-hover';
    card.setAttribute('data-title', media.Title); // Store title for easy removal
    card.setAttribute('data-year', media.Year);
    card.setAttribute('data-rate', media.imdbRating);

    const img = document.createElement('img');
    img.src = media.Poster === 'N/A'? '../assets/no_image.jpg' : media.Poster;
    img.className = 'mb-2 img-fluid';

    const title = document.createElement('h6');
    title.className = 'text-secondary';
    title.textContent = media.Type === 'movie' ? `Film: ${media.Title}` : `Show: ${media.Title}`;

    const year = document.createElement('p');
    year.className = 'text-secondary';
    year.textContent = media.Year;

    const rating = document.createElement('small');
    rating.className = 'text-secondary';
    rating.textContent =  media.imdbRating ? `IMDb Rate: ${media.imdbRating}`: `IMDb Rate: N/A`;

    const iconDiv = document.createElement('div');
    iconDiv.classList.add('icon');
    const icon = document.createElement('i');
    if(!showIcon){
        icon.className = 'bi bi-heart-fill custom-cursor-pointer';
    }else{
        icon.className = 'bi bi-heart custom-cursor-pointer';
    }
    icon.addEventListener('click', toggleFavorite);

    iconDiv.appendChild(icon);

    card.appendChild(img);
    card.appendChild(title);
    card.appendChild(year);
    card.appendChild(rating);
    card.appendChild(iconDiv);
    // if(showIcon){
    //     card.appendChild(iconDiv);
    // }

    return card;
}

// Helper function to display a message
function displayMessage(message, container = moviesContainer) {
    container.innerHTML = `<p class="text-secondary">${message}</p>`;
}

// Async function to fetch data from OMDb API
async function fetchData(url) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Fetch error:', error);
        displayMessage(`Error: ${error.message}`);
        throw error; // Re-throw to be caught by caller
    }
}

// Async function to fetch movie/show details and display them
async function fetchAndDisplayMedia(title) {
    try {
        const url = `http://www.omdbapi.com/?s=${encodeURIComponent(title)}&apikey=${APIKEY}`;
        const data = await fetchData(url);

        if (data.Response === 'True') {
            noResultContainer.classList.add('d-none');
            moviesContainer.innerHTML = '';
            showsContainer.innerHTML = '';
            const mediaItems = data.Search;

             await Promise.all(mediaItems.map(async (item) => { // use await here
                const ratingData = await fetchRating(item.Title);
                item.imdbRating = ratingData.imdbRating;
            }));

            mediaItems.forEach(media => {
                const card = createMediaCard(media);
                if (media.Type === 'movie') {
                    movieSection.classList.remove('d-none');
                    movieLine.classList.remove('d-none');
                    moviesContainer.appendChild(card);
                } else {
                    showSection.classList.remove('d-none');
                    showLine.classList.remove('d-none');
                    showsContainer.appendChild(card);
                }
            });
            document.getElementById('movieSection').scrollIntoView({ behavior: 'smooth', block: 'start' });
        } else {
            moviesContainer.innerHTML = '';
            showsContainer.innerHTML = '';
            movieSection.classList.add('d-none');
            movieLine.classList.add('d-none');
            showSection.classList.add('d-none');
            showLine.classList.add('d-none');
            noResultContainer.classList.remove('d-none');
            noResultMsg.innerText = `No results found for "${title}"`;
            noResultContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    } catch (error) {
        // Handle errors from fetchData
        console.error('Error fetching and displaying media:', error);
        displayMessage('An error occurred. Please check your network connection and try again.');
    }
}

// Function to handle Enter key press in the search input
searchInput.addEventListener('keypress', (event) => {
    if (event.key === 'Enter') {
        event.preventDefault();
        const searchTerm = searchInput.value.trim();
        if (searchTerm) {
            fetchAndDisplayMedia(searchTerm);
        } else {
            alert('Please enter a title to search.');
        }
    }
});

// Async function to fetch rating
async function fetchRating(title) {
    const url = `http://www.omdbapi.com/?t=${encodeURIComponent(title)}&apikey=${APIKEY}`;
    try {
        const response = await fetch(url);
        const data = await response.json();
        return data; // Return the whole data object
    } catch (error) {
        console.error('Error fetching rating:', error);
        return { imdbRating: 'N/A' };
    }
}

// Function to handle adding/removing a movie/show to favorites
function toggleFavorite(event) {
    const icon = event.target;
    const card = icon.closest('.main-card');
    const title = card.getAttribute('data-title');
    const year = card.getAttribute('data-year');
    const rate = card.getAttribute('data-rate');
    
    if (icon.classList.contains('bi-heart')) {
        icon.classList.remove('bi-heart');
        icon.classList.add('bi-heart-fill', 'liked');
        // Add to favorites array
        const mediaObject = {
            Title: title,
            Year: year,
            imdbRating: rate,
            Poster: card.querySelector('img').src, // Get poster from the card
            Type: title.includes("Show") ? "series" : "movie"
        };
        favorites.push(mediaObject);
        updateFavoriteSection(); // Update display
        // console.log(container);
    } else {
        icon.classList.remove('bi-heart-fill', 'liked');
        icon.classList.add('bi-heart');
        // Remove from favorites array
        const indexToRemove = favorites.findIndex(item => item.Title === title && item.Year === year);
        if (indexToRemove !== -1) {
            // get the title and the year of the card will be removed from favorites 
            const title = favorites[indexToRemove].Title;
            const year = favorites[indexToRemove].Year;
            // hold the original card of the one will be removed from the favorites
            const original = document.querySelector(`.main-card[data-title="${title}"][data-year="${year}"]`);
            if(original){
                // hold the icon inside the original card to edit it
                const originalIcon = original.querySelector('i');
                if (originalIcon) {
                    // console.log(originalIcon);
                    originalIcon.classList.add('bi-heart');
                    originalIcon.classList.remove('bi-heart-fill', 'liked');
                }
            }
                favorites.splice(indexToRemove, 1);
                updateFavoriteSection(); // Update display
        }
    }
}

function updateFavoriteSection() {
    favoriteContainer.innerHTML = ''; // Clear the container
    if (favorites.length === 0) {
        favoriteSection.classList.add('d-none');
    } else {
        favoriteSection.classList.remove('d-none');
        favorites.forEach(media => {
            const card = createMediaCard(media, false);
            favoriteContainer.appendChild(card);
            document.getElementById('favoriteContainer').scrollIntoView({ behavior: 'smooth', block: 'start' });
        });
    }
}
